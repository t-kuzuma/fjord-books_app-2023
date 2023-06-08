class ReportsController < ApplicationController
  before_action :set_report, only: %i[ show edit update destroy ]

  def index
    @reports = Report.all
  end

  def show
  end

  def new
    @report = Report.new
  end

  def edit
    unless current_user == @report.user
      redirect_to reports_url, alert: "他の人の日報は編集できないよ"
    end
  end

  def create
    @report = current_user.reports.build(report_params)

    if @report.save
      redirect_to report_url(@report), notice: "Report was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      redirect_to report_url(@report), notice: "Report was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user == @report.user
      @report.destroy 
      redirect_to reports_url, notice: "Report was successfully destroyed."
    else
      redirect_to reports_url, alert: "他の人の日報は削除できないよ"
    end
  end

  private
    def set_report
      @report = Report.find(params[:id])
    end

    def report_params
      params.require(:report).permit(:user_id, :title, :content)
    end
end
