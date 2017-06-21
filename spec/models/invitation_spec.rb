# Copyright (c) 2016 Banff International Research Station.
# This file is part of Workshops. Workshops is licensed under
# the GNU Affero General Public License as published by the
# Free Software Foundation, version 3 of the License.
# See the COPYRIGHT file for details and exceptions.

require 'rails_helper'

RSpec.describe 'Model validations: Invitation', type: :model do
  it 'has valid factory' do
    expect(build(:invitation)).to be_valid
  end

  it 'requires a membership' do
    i = build(:invitation, membership: nil)
    expect(i.valid?).to be_falsey
  end

  it 'requires invited_by' do
    i = build(:invitation)
    i.invited_by = nil
    expect(i.valid?).to be_falsey
  end

  it 'requires a code' do
    i = build(:invitation, code: nil)
    expect(i.valid?).to be_falsey
  end

  it 'sets expires on save' do
    i = build(:invitation)
    expect(i.expires).to be_nil
    i.save
    expect(i.expires).not_to be_nil
  end

  it 'derives expiry date from Setting + event' do
    event = build(:event)
    membership = build(:membership, event: event)
    Setting.Site['rsvp_expiry'] = '1.month'
    i = create(:invitation, membership: membership)

    expect(i.expires.to_date).to eq((event.start_date - 1.month).to_date)
  end
end
