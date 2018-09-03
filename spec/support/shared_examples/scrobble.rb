require 'rails_helper'

# +subject+ must be a new instance of the record.
shared_examples_for Scrobble do
  it_behaves_like HasGuid
  it_behaves_like Periodable

  it { should validate_presence_of :category }
  it { should validate_presence_of :start_time }
  it { should validate_presence_of :end_time }
end
