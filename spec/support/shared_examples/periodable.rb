require 'rails_helper'

# +subject+ must be a new instance of the record.
shared_examples_for Periodable do
  it { should have_db_index :start_time }
  it { should have_db_index :end_time }
  it { should have_db_index :period }

  it 'does not initialize with the period value set' do
    expect(subject.period).to be_nil
  end

  it 'sets a value for period on save' do
    subject.save!
    expect(subject.period).to be_present
  end

  it 'does not change the value for period on subsequent saves' do
    subject.save!

    expect { subject.save! }.to_not change(subject, :period)
  end
end
