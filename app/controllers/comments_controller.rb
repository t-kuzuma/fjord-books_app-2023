# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: :destroy
  before_action :redirect_unless_current_user, only: :destroy

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      render_commentable
    end
  end

  def destroy
    @comment.destroy
    redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def redirect_unless_current_user
    return if current_user == @commentable.user

    redirect_to @commentable, alert: t('errors.messages.other_user')
  end
end
