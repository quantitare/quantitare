require 'rails_helper'

# +subject+ must be a new instance of the record.
shared_examples_for HasGuid do
  it { should have_db_index :guid }

  it 'sets a value on save' do
    subject.save!
    expect(subject.guid).to be_present
  end

  it 'does not change the value on subsequent saves' do
    subject.save!

    expect { subject.save! }.to_not change(subject, :guid)
  end
end
