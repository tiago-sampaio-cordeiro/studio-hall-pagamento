class Employee < ApplicationRecord
  belongs_to :user
  has_many :time_punches, dependent: :destroy

  enum :contract_type, { freelancer: 0, clt: 1 }

  validates :contract_type, presence: true
  validates :hourly_rate, presence: true, numericality: { greater_than: 0 }, if: :freelancer?
  validates :salary, presence: true, numericality: { greater_than: 0 }, if: :clt?

  def next_punch_kind
    last = Current.user.employee.time_punches.order(:punched_at).last
    last&.clock_in? ? "clock_out" : "clock_in"
  end
end
