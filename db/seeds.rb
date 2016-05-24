Message.destroy_all
User.destroy_all
Room.destroy_all

peter = User.create!(email:'peter@example.com', password: '123123', token: '')
mary = User.create!(email:'mary@example.com', password: '123123', token: '')
henry = User.create!(email:'henry@example.com', password: '123123', token: '')
cathy = User.create!(email:'cathy@example.com', password: '123123', token: '')

room_mary = Room.create!(receivers: [peter.id, mary.id])
room_henry = Room.create!(receivers: [peter.id, henry.id])
room_everyone = Room.create!(receivers: [peter.id, mary.id, henry.id, cathy.id])

[
  [peter, "Hello Mary"],
  [mary, "Hello Peter"],
  [peter, "How are you today?"],
  [mary, "I am very fine."],
  [mary, "Thank you for asking, Peter!"],
].each do |user, message|
  room = room_mary

  p Message.create!(
    receivers: room.receivers, 
    room_id: room.id, 
    user_id: user.id, 
    content: message
  )
end

[
  [peter, "Hello Henry"],
  [henry, "Hello Peter"],
  [peter, "Where is my lunch?"],
  [henry, "erm..."],
  [henry, "Sorry I ate it!!!"],
  [peter, "you.. you.. you.. :X"],
].each do |user, message|
  room = room_henry

  p Message.create!(
    receivers: room.receivers, 
    room_id: room.id, 
    user_id: user.id, 
    content: message
  )
end

[
  [peter, "Hi I am Peter"],
  [henry, "Hi I am Henry"],
  [cathy, "Hi I am Cathy"],
  [mary, "Hi I am Mary"],
  [peter, "Did you know Henry ate my lunch?"],
  [cathy, "That's horrible!"],
  [henry, "i am really sorry..."],
].each do |user, message|
  room = room_everyone

  p Message.create!(
    receivers: room.receivers, 
    room_id: room.id, 
    user_id: user.id, 
    content: message
  )
end
