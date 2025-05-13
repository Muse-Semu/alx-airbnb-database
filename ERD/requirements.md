@startuml
' Define entities and their attributes
entity "User" {
  * user_id : UUID <<PK>>
  --
  first_name : VARCHAR <<NOT NULL>>
  last_name : VARCHAR <<NOT NULL>>
  email : VARCHAR <<UNIQUE, NOT NULL>>
  password_hash : VARCHAR <<NOT NULL>>
  phone_number : VARCHAR
  role : ENUM(guest, host, admin) <<NOT NULL>>
  created_at : TIMESTAMP <<DEFAULT CURRENT_TIMESTAMP>>
}

entity "Property" {
  * property_id : UUID <<PK>>
  --
  host_id : UUID <<FK>>
  name : VARCHAR <<NOT NULL>>
  description : TEXT <<NOT NULL>>
  location : VARCHAR <<NOT NULL>>
  pricepernight : DECIMAL <<NOT NULL>>
  created_at : TIMESTAMP <<DEFAULT CURRENT_TIMESTAMP>>
  updated_at : TIMESTAMP <<ON UPDATE CURRENT_TIMESTAMP>>
}

entity "Booking" {
  * booking_id : UUID <<PK>>
  --
  property_id : UUID <<FK>>
  user_id : UUID <<FK>>
  start_date : DATE <<NOT NULL>>
  end_date : DATE <<NOT NULL>>
  total_price : DECIMAL <<NOT NULL>>
  status : ENUM(pending, confirmed, canceled) <<NOT NULL>>
  created_at : TIMESTAMP <<DEFAULT CURRENT_TIMESTAMP>>
}

entity "Payment" {
  * payment_id : UUID <<PK>>
  --
  booking_id : UUID <<FK>>
  amount : DECIMAL <<NOT NULL>>
  payment_date : TIMESTAMP <<DEFAULT CURRENT_TIMESTAMP>>
  payment_method : ENUM(credit_card, paypal, stripe) <<NOT NULL>>
}

entity "Review" {
  * review_id : UUID <<PK>>
  --
  property_id : UUID <<FK>>
  user_id : UUID <<FK>>
  rating : INTEGER <<CHECK: 1-5, NOT NULL>>
  comment : TEXT <<NOT NULL>>
  created_at : TIMESTAMP <<DEFAULT CURRENT_TIMESTAMP>>
}

entity "Message" {
  * message_id : UUID <<PK>>
  --
  sender_id : UUID <<FK>>
  recipient_id : UUID <<FK>>
  message_body : TEXT <<NOT NULL>>
  sent_at : TIMESTAMP <<DEFAULT CURRENT_TIMESTAMP>>
}

' Define relationships
User ||--o{ Property : hosts
User ||--o{ Booking : books
Property ||--o{ Booking : booked
Booking ||--o{ Payment : paid
Property ||--o{ Review : reviewed
User ||--o{ Review : writes
User ||--o{ Message : sends
User ||--o{ Message : receives

' Notes for constraints and indexes
note right of User
  Unique constraint on email
  Index on email
end note

note right of Property
  Index on property_id
end note

note right of Booking
  Index on booking_id
  Index on property_id
end note

note right of Payment
  Index on booking_id
end note

' Styling
skinparam monochrome true
skinparam shadowing false
skinparam class {
  BackgroundColor White
  BorderColor Black
  ArrowColor Black
}

@enduml
