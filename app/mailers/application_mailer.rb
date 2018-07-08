# frozen_string_literal: true

##
# Abstract class for mailers
#
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
