# frozen_string_literal: true

module Aux
  ##
  # An author or committer for a {Aux::CodeCommit}
  #
  class CodeParticipant
    include AttrJson::Model

    attr_json :name, :string
    attr_json :email, :string
    attr_json :date, :datetime
    attr_json :avatar_url, :string
  end
end
