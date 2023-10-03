require "csv"

class Meritadmin::ReportService
  include Friendable

  def initialize(report, date_ranges)
    @report = report
    @date_ranges = determine_date_ranges(date_ranges)
  end

  def self.generate(report_type, date_ranges)
    self.new(Report.new(report_type: report_type), date_ranges).run
  end

  def run
    csv =
      case @report.report_type
      when "Students Online Time"
        generate_online_activity_report("#{Rails.root}/tmp/online-activity.csv")
      end

    csv if @report.save && csv.present?
  end

  private

  def determine_date_ranges(date_ranges)
    case date_ranges
    when "Today"
      [Time.now.beginning_of_day, Time.now.end_of_day]
    when "Yesterday"
      [1.day.ago.localtime.beginning_of_day, 1.day.ago.localtime.end_of_day]
    when "Last 7 Days"
      [7.days.ago.localtime.beginning_of_day, Time.now.end_of_day]
    when "Last Month"
      [1.month.ago.localtime.beginning_of_day, Time.now.end_of_day]
    when "Last 3 Months"
      [3.months.ago.localtime.beginning_of_day, Time.now.end_of_day]
    when "Last 6 Months"
      [6.months.ago.localtime.beginning_of_day, Time.now.end_of_day]
    when "This Year"
      [1.year.ago.localtime.beginning_of_day, Time.now.end_of_day]
    when "All Time"
      [10.years.ago.localtime.beginning_of_day, Time.now.end_of_day]
    end
  end

  def generate_online_activity_report(filename)
    events = Event.where(message_type: "online", created_at: @date_ranges[0]..@date_ranges[1]).where.not(uuid: ["", nil])

    student_uuids = events.pluck(:uuid).reject { |c| c.empty? }
    students = Student.where(uuid: student_uuids)

    CSV.generate do |writer|
      writer << [
        "Student Name",
        "Student Email",
        "Total Time Spent Online"
      ]

      students.map do |student|
        student_events = events.select { |e| e.uuid == student.uuid }
        student_events_with_60_seconds_in_between = Set[*student_events].divide { |x,y| (x.created_at-y.created_at).abs <= 60 }

        writer << [
          student.name,
          student.email,
          friendly_full_duration_for(student_events_with_60_seconds_in_between.count)
        ]
      end
    end
  end
end
