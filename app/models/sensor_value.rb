class SensorValue < ApplicationRecord
  belongs_to :sensor

  validates_presence_of :value, :registered_at
  validates_uniqueness_of :registered_at

  scope :limit_to_n_elements, (lambda do |count|
    select('sensor_values.*')
    .from(
      <<-SQL
        (SELECT t.*, 
                ROW_NUMBER() OVER(ORDER BY t.registered_at) as rnk,
                COUNT(*) OVER() as total_cnt
         FROM sensor_values t) sensor_values
      SQL
    ).where('MOD(sensor_values.rnk,(total_cnt/?)) = 0', count)
  end)

  scope :filter_by_dates, (lambda do |from, to|
    where(
      %(
        (registered_at between :from and :to) or
        (registered_at > :from and :to IS NULL) or
        (registered_at < :to and :from IS NULL) or
        (:to is NULL and :from IS NULL)
      ), from: from, to: to
    )
  end)
end
