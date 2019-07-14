# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScrobblersController do
  let!(:user) { create :user }

  before { sign_in(user) }

  describe 'GET index' do
    let!(:user_scrobbler) { create :scrobbler, user: user }
    let!(:non_user_scrobbler) { create :scrobbler }

    let(:action) { get :index }

    it_behaves_like 'authenticated_action'

    it 'ensures the non_user_scrobbler does not belong to the user' do
      expect(non_user_scrobbler.user).to_not eq(user)
    end

    it 'includes scrobblers that belong to the user' do
      action
      expect(assigns(:scrobblers)).to include(user_scrobbler)
    end

    it 'does not include scrobblers that do not belong to the user' do
      action
      expect(assigns(:scrobblers)).to_not include(non_user_scrobbler)
    end
  end

  describe 'GET new' do
    let(:action) { get :new }

    it_behaves_like 'authenticated_action'

    it 'sets a fresh scrobbler' do
      action
      expect(assigns(:scrobbler)).to be_a_new(Scrobbler)
    end

    it 'renders the :new template' do
      action
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:params) { { scrobbler: { type: Scrobblers::DummyScrobbler.name, name: 'scrobbler1' } } }
    let(:action) { post :create, params: params, format: :js }

    it_behaves_like 'authenticated_action'

    it 'creates a new scrobbler' do
      expect { action }.to change(Scrobbler, :count).by(1)
    end

    it 'assigns the scrobbler to an ivar' do
      action
      expect(assigns(:scrobbler)).to be_persisted
    end

    it 'sets the user properly' do
      action
      expect(assigns(:scrobbler).user).to eq(user)
    end

    it 'does not allow the user to choose the user' do
      params[:scrobbler][:user_id] = create(:user).id

      action
      expect(assigns(:scrobbler).user).to eq(user)
    end
  end

  describe 'GET edit' do
    let(:scrobbler) { create :scrobbler, user: user }
    let(:action) { get :edit, params: { id: scrobbler.id } }

    it_behaves_like 'authenticated_action'

    it 'pull the correct scrobbler' do
      action
      expect(assigns(:scrobbler)).to eq(scrobbler)
    end

    it 'renders the proper template' do
      action
      expect(response).to render_template(:edit)
    end

    it "does not allow the user to edit other users' scrobblers" do
      get :edit, params: { id: create(:scrobbler).id }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PATCH update' do
    let(:scrobbler) { create :scrobbler, user: user }
    let(:params) { { id: scrobbler.id, scrobbler: { name: 'some new name' } } }
    let(:action) { patch :update, params: params, format: :js }

    it_behaves_like 'authenticated_action'

    it 'assigns the correct scrobbler' do
      action
      expect(assigns(:scrobbler)).to eq(scrobbler)
    end

    it 'updates the scrobbler without errors' do
      action
      expect(assigns(:scrobbler)).to be_valid
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
    let!(:scrobbler) { create :scrobbler, user: user }
    let(:action) { delete :destroy, params: { id: scrobbler.id } }

    it_behaves_like 'authenticated_action'

    it 'destroys the record' do
      expect { action }.to change(Scrobbler, :count).by(-1)
    end

    it 'redirects to the index' do
      action
      expect(response).to redirect_to(scrobblers_path)
    end

    context "when the user attempts to destroy another user's scrobbler" do
      let!(:scrobbler) { create :scrobbler }

      it "does not let the user destroy other users' scrobblers" do
        action
        expect(response).to have_http_status(:not_found)
      end

      it 'does not destroy any records' do
        expect { action }.to_not change(Scrobbler, :count)
      end
    end
  end
end
