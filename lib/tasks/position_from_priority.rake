namespace :redmine do
  namespace :backlogs do
    desc "Remove duplicate positions in the issues table"
    task :fix_positions => :environment do
      unless Backlogs.migrated?
        puts "Please run plugin migrations first"
      else
        RbStory.transaction do
          ids = RbStory.connection.select_values('select id
                                                  from issues
                                                  join enumerations on issues.priority_id = enumerations.id
                                                  order by enumerations.position')
          ids.each_with_index{|id, i|
            RbStory.connection.execute("update issues set position = #{i * RbStory.list_spacing} where id = #{id}")
          }
        end
      end
    end
  end
end
