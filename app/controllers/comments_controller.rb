class CommentsController < ApplicationController
  def create
    comment = Comment.new(comment_params)
    if comment.save
       redirect_to "/items/#{comment.item.id}" 
    else
      render "items/show"
    end
      
    
  end

  private
  def comment_params
    params.require(:comment).permit(:comment).merge(user_id: current_user.id,item_id: params[:item_id] )

  end
end

