class CommentsController < ApplicationController
  before_action :set_comment, only: :destroy

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: "Comment was successfully created."
    else
    end
  end

  def destroy
    if current_user == @comment.user
      @comment.destroy
      redirect_to @commentable, notice: "Comment was successfully destroyed."
    else
      redirect_to @commentable, alert: "他の人のコメントは削除できないよ"
    end
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
