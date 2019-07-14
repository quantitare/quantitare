# frozen_string_literal: true

json.url model_url_for(model)
json.isNewRecord model.new_record?
json.errors model.errors.messages
