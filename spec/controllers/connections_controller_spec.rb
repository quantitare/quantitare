require 'rails_helper'

RSpec.describe ConnectionsController do
  let!(:user) { create :user }

  before do
    sign_in user
  end

  describe 'GET index' do
    let!(:user_non_service_scrobbler) { create :scrobbler, user: user }
    let!(:user_service_scrobbler) { create :twitter_scrobbler, user: user }
    let!(:non_user_scrobbler) { create :scrobbler }

    let(:action) { get :index }

    it_behaves_like 'authenticated_action'

    it 'ensures the non_user_scrobbler does not belong to the user' do
      expect(non_user_scrobbler.user).to_not eq(user)
    end

    it 'includes scrobblers that belong to the user' do
      action
      expect(assigns(:scrobblers)).to include(user_non_service_scrobbler)
    end

    it 'includes service scrobblers that belong to the user' do
      action
      expect(assigns(:scrobblers)).to include(user_service_scrobbler)
    end

    it 'does not include scrobblers that do not belong to the user' do
      action
      expect(assigns(:scrobblers)).to_not include(non_user_scrobbler)
    end
  end

  describe 'GET show' do
    let(:scrobbler) { create :scrobbler, user: user }
    let(:action) { get :show, params: { id: scrobbler.id } }

    it_behaves_like 'authenticated_action'

    it 'pull the correct scrobbler' do
      action
      expect(assigns(:scrobbler)).to eq(scrobbler)
    end

    it 'renders the proper template' do
      action
      expect(response).to render_template(:show)
    end

    it "does not allow the user to see other users' scrobblers" do
      get :show, params: { id: create(:scrobbler).id }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET new' do
    let(:action) { get :new }

    it_behaves_like 'authenticated_action'

    context 'when a service_id is provided' do
      let(:service) { create :service, :twitter }
      let(:action) { get :new, params: { service_id: service.id } }

      it 'sets a fresh scrobbler' do
        action
        expect(assigns(:scrobbler)).to be_a_new(Scrobblers::TwitterScrobbler)
      end

      it 'sets the name of the fresh scrobbler' do
        action
        expect(assigns(:scrobbler).name).to match(/Twitter/)
      end

      it 'renders the :new template' do
        action
        expect(response).to render_template(:new)
      end

      context 'when a scrobbler already exists for that service' do
        let!(:scrobbler) { create :twitter_scrobbler, service: service, user: user }

        it 'redirects back to connections#index' do
          action
          expect(response).to redirect_to(connection_path(scrobbler))
        end

        it 'sets the flash' do
          action
          expect(response.flash[:primary]).to be_present
        end
      end

      context 'when the service does not exist' do
        let(:action) { get :new, params: { service_id: nil } }

        it 'has a 404 status' do
          action
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when an oauth provider name is provided' do
      let(:action) { get :new, params: { provider: 'twitter' } }

      it 'redirects to the oauth authorize path' do
        action
        expect(response).to redirect_to(user_twitter_omniauth_authorize_path)
      end
    end

    context 'when a non-oauth provider name is provided' do
      let(:action) { get :new, params: { provider: 'dummy' } }

      it 'initializes the appropriate scrobbler' do
        action
        expect(assigns(:scrobbler)).to be_a_new(Scrobblers::DummyScrobbler)
      end

      it 'sets the name of the provider' do
        action
        expect(assigns(:scrobbler).name).to match(/Dummy/)
      end
    end

    context 'when both provider and service_id are given' do
      let(:action) { get :new, params: { provider: 'dummy', service_id: create(:service).id } }

      it 'sets the flash' do
        action
        expect(flash[:danger]).to be_present
      end

      it 'redirects to connections#index' do
        action
        expect(response).to redirect_to(connections_path)
      end
    end
  end

  describe 'POST create' do
    let(:params) { { scrobbler: { type: Scrobblers::DummyScrobbler.name, name: 'hello' } } }
    let(:action) { post :create, params: params, format: :js }

    it_behaves_like 'authenticated_action'

    it 'creates a new scrobbler' do
      expect { action }.to change(Scrobbler, :count).by(1)
    end

    it 'sets the user properly' do
      action
      expect(Scrobbler.last.user).to eq(user)
    end

    it 'does not allow the user to choose the user' do
      params[:scrobbler][:user_id] = create(:user).id

      action
      expect(Scrobbler.last.user).to eq(user)
    end

    it 'redirects to connections#index' do
      action
      expect(response.body).to include('window.location=')
    end

    context 'with invalid params' do
      let(:params) { { scrobbler: { type: Scrobblers::DummyScrobbler.name, name: nil } } }

      it 'renders the :create template' do
        action
        expect(response).to render_template(:create)
      end
    end
  end

  describe 'PATCH update' do
    let(:scrobbler) { create :scrobbler, user: user }
    let(:params) { { id: scrobbler.id, scrobbler: { name: 'some new name' } } }
    let(:action) { patch :update, params: params, format: :js }

    it_behaves_like 'authenticated_action'

    render_views

    it 'assigns the correct scrobbler' do
      action
      expect(assigns(:scrobbler)).to eq(scrobbler)
    end

    it 'updates the scrobbler without errors' do
      action
      expect(assigns(:scrobbler)).to be_valid
    end

    it 'renders form' do
      action
      expect(response.body).to include('<form')
    end

    context 'with invalid params' do
      let(:params) { { id: scrobbler.id, scrobbler: { name: '' } } }

      it 'renders :update' do
        action
        expect(response).to render_template(:update)
      end
    end

    context "when the user attempts to update another user's scrobbler" do
      let(:scrobbler) { create :scrobbler }

      it "does not let the user update other users' scrobblers" do
        action
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:service) { create :service, :twitter, user: user }
    let(:action) { delete :destroy, params: { id: service.id } }

    it_behaves_like 'authenticated_action'

    it 'destroys the record' do
      expect { action }.to change(Service, :count).by(-1)
    end

    it 'redirects to the index' do
      action
      expect(response).to redirect_to(connections_path)
    end

    context 'when there are scrobblers created for the service' do
      let!(:scrobbler) { create :twitter_scrobbler, service: service, user: user }

      it 'destroys the scrobbler' do
        action
        expect { scrobbler.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when the user attempts to destroy another user's scrobbler" do
      let!(:service) { create :service, :twitter }

      it "does not let the user destroy other users' scrobblers" do
        action
        expect(response).to have_http_status(:not_found)
      end

      it 'does not destroy any records' do
        expect { action }.to_not change(Service, :count)
      end
    end
  end
end
