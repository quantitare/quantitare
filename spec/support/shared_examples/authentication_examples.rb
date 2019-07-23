# frozen_string_literal: true

require 'rails_helper'

# Requires in scope: user and action
RSpec.shared_examples 'authenticated_action' do
  context 'when thre is no user' do
    before { sign_out(user) }

    it 'redirects to the login screen' do
      action

      if request.format.js?
        expect(response).to have_http_status(:unauthorized)
      else
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context 'when there is a user' do
    before { sign_in(user) }

    it 'does not respond with a server error' do
      action
      expect(response).to_not be_server_error
    end

    it 'does not respond with a client error' do
      action
      expect(response).to_not be_client_error
    end
  end
end
