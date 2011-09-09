class LastMessagesHooks < Redmine::Hook::ViewListener
  

    def view_welcome_index_right(context = { })
      if !User.current.projects.any?
        return ''
      end
       messages =  Message.find(:all, :limit => 5,
                                             :order => "#{Message.table_name}.created_on DESC",
                                             :conditions => "#{Board.table_name}.project_id in (#{User.current.projects.collect{|m| m.id}.join(',')})",
                                             :include => [:author, :board])
      block = HomeBlock.find_by_name('forum_messages')
      context[:controller].send(:render_to_string, {:locals => {:messages => messages}.merge(context), :file => "/messages/message_box"}) if block
    end      

    def view_projects_show_right(context = { })
       messages =  Message.find(:all, :limit => 5,
                                             :order => "#{Message.table_name}.created_on DESC",
                                             :conditions => "#{Board.table_name}.project_id = (#{context[:project].id})",
                                             :include => [:author, :board])

      project = context[:project]
      block = OverviewBlock.find_by_project_id_and_name(project,'forum_messages')
      context[:controller].send(:render_to_string, {:locals => {:messages => messages}.merge(context), :file => "/messages/message_box"}) if block
    end
end