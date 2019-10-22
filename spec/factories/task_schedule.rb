FactoryBot.define do
  factory :task_schedule do
    start { DateTime.now + 1.day }
    stop { DateTime.now + 2.days }
    days {
      {
        mon: { on: nil, off: nil },
        tue: { on: nil, off: nil },
        wed: { on: nil, off: nil },
        thu: { on: nil, off: nil },
        fri: { on: nil, off: nil },
        sat: { on: nil, off: nil },
        sun: { on: nil, off: nil }        
      }
    }

    association :task, factory: :task
  end
end
