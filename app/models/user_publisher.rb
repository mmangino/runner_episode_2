class UserPublisher < Facebooker::Rails::Publisher
  
  def run_template
    one_line_story_template "{*actor*} went for a {*distance*} mile run. {*marketing_link*}"
    one_line_story_template "{*actor*} went for a run."
    short_story_template "{*actor*} went for a {*distance*} mile run. {*marketing_link*}", "They said: {*body*}"
    short_story_template "{*actor*} went for a run.", "They had a great time."
  end
  
  def cheer(cheering_user,run)
    send_as :notification
    from cheering_user.facebook_session.user
    recipients run.user
    fbml "says great job on your run!"
  end
  
  def run(run)
    send_as :user_action
    from run.user.facebook_session.user
    data :body => run.description, 
         :distance => run.distance, 
         :marketing_link => link_to("View all runs", user_runs_url(run.user))
  end
  
  def profile_update(user)
    send_as :profile
    recipients user
    profile render(:partial=>"users/profile_boxes", 
                        :assigns=>{:user=>user})
    profile_main render(:partial=>"users/profile", 
                        :assigns=>{:user=>user})
  end
  
end
