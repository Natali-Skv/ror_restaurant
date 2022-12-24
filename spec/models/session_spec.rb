# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Session, type: :model do
  it 'should check true code' do
    phone = '79_015_020_456'
    code = '1234'
    expect(Session).to receive(:get_code_from_cach).with(Session.phone_to_i(phone)).and_return(code)
    expect(Session.checkcode(phone, code)).to eq([
                                                   User.new(id: 1, name: nil, phone: 79_015_020_456,
                                                            cart: '{}'), nil
                                                 ])
  end

  it 'should check true code and create new user' do
    phone = '79_015_020_456'
    code = '1234'
    expect(Session).to receive(:get_code_from_cach).with(Session.phone_to_i(phone)).and_return(code)
    user, err = Session.checkcode(phone, code)
    expect([user, err]).to eq([User.new(id: 1, name: nil, phone: 79_015_020_456, cart: '{}'), nil])
    expect(User.exists?(id: user.id))
  end

  it 'should check true code and return existing user' do
    phone = '79_015_020_456'
    code = '1234'

    user = User.create(phone: Session.phone_to_i(phone), cart: '{}')
    expect(user.valid?).to be true

    initial_user_count = User.count

    expect(Session).to receive(:get_code_from_cach).with(Session.phone_to_i(phone)).and_return(code)

    expect(Session.checkcode(phone, code)).to eq([User.new(id: 1, name: nil, phone: 79_015_020_456, cart: '{}'), nil])
    expect User.count == initial_user_count + 1
  end

  it 'should check wrong code' do
    phone = '79_015_020_456'
    true_code = '1234'
    wrong_code = '0000'
    expect(Session).to receive(:get_code_from_cach).with(Session.phone_to_i(phone)).and_return(true_code)
    expect(Session.checkcode(phone, wrong_code)).to eq([nil, Session::ERRORS[:WRONG_CODE]])
  end

  it 'should check wrong code' do
    phone = '79_015_020_456'
    true_code = '1234'
    wrong_code = '0000'
    expect(Session).to receive(:get_code_from_cach).with(Session.phone_to_i(phone)).and_return(true_code)
    expect(Session.checkcode(phone, wrong_code)).to eq([nil, Session::ERRORS[:WRONG_CODE]])
  end

  it 'should check invalid code' do
    phone = '79_015_020_456'
    invalid_code = '000'
    expect(Session.checkcode(phone, invalid_code)).to eq([nil, Session::ERRORS[:INVALID_CODE]])
  end

  it 'should return internal server error if cannot to create user ' do
    phone = '79_015_020_456'
    code = '1234'
    expect(Session).to receive(:get_code_from_cach).with(Session.phone_to_i(phone)).and_return(code)
    expect(User).to receive(:create).with(phone: Session.phone_to_i(phone), cart: '{}').and_return(User.new)
    expect(Session.checkcode(phone, code)).to eq([nil, Session::ERRORS[:INTERNAL_ERROR]])
  end

  it 'should check invalid phone' do
    too_short_phone = '79_015_020_45'
    true_code = '1234'
    expect(Session.checkcode(too_short_phone, true_code)).to eq([nil, Session::ERRORS[:INVALID_PHONE]])
  end

  it 'should send code' do
    phone = '79_015_020_456'
    code = '1234'
    expect(Session).to receive(:flashcall).with(Session.phone_to_i(phone), code).and_return(nil)
    expect(Session).to receive(:add_code_to_cach).with(Session.phone_to_i(phone), code).and_return(nil)
    expect(Session.sendcode(phone)).to be_nil
  end
end
