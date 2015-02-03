class Permission < Struct.new(:user)
  
  # Control access to pages based off the current_user, controller, action and params
  def allow?(controller, action, params)  
    return true if controller == 'sessions'
    return true if controller == 'pages' && action.in?(%w[landing about])
    return true if controller == 'users' && action.in?(%w[index show])
    
    if user
      return true if controller == 'staff' && action.in?(%w[index])
      return true if controller == 'notifications' && action.in?(%w[index show])
      if controller == 'users' && action.in?(%w[update])
        @user = User.find(params[:id])
        return { user: @user } if @user == user
      end
      
      if user.admin?
        return true if controller == 'pages' && action.in?(%w[dashboard])
        return true if controller == 'lists' && action.in?(%w[index create show])
        
        if controller == 'lists' && action.in?(%w[edit update destroy])
          @list = List.find(params[:id])
          return { list: @list } if @list.try(:user) == user
        end
      end
      
      return true if user.super_admin?  
    end
    
    # Otherwise, don't allow access
    return false
  end
  
end