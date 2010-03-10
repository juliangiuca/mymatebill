Factory.define :user do |u|
  u.name                  'test login'
  u.login                 'test_login'
  u.email                 'test@eggandjam.com'
  u.password              'test123'
  u.password_confirmation 'test123'
end

Factory.define :event do |e|
  e.description           'This is a test event'
  e.amount                '123'
end

Factory.define :account do |a|
  a.name                  'Test account'
end
