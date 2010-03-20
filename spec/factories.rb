Factory.define :user do |u|
  u.name                  'test login'
  u.login                 'test_login'
  u.email                 'test@eggandjam.com'
  u.password              'test123'
  u.password_confirmation 'test123'
end

Factory.define :actor do |a|
  a.name                  "Rent"
  a.user_id               {(User.first || Factory(:user)).id}
end

Factory.define :account do |a|
  a.name                  'Test account'
  a.user_id               {(User.find_by_name("test login") || Factory(:user)).id}
end

Factory.define :event do |e|
  e.description           'This is a test event'
  e.amount                '123'
  e.actor_id              {(Actor.first || Factory(:actor)).id}
  e.account_id            {(Account.first || Factory(:account)).id}
end

Factory.define :friend do |f|
  f.name                  "Friendly name"
  f.user_id               {(User.first || Factory(:user)).id}
end

Factory.define :line_item do |l|
  l.amount                1
  l.event_id              {(Event.first || Factory(:event)).id}
  l.friend_id             {(Friend.first || Factory(:friend)).id}
end
