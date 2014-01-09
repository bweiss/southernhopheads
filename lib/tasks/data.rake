namespace :data do
  desc "Import breweries and beers"
  task :import_beers => :environment do
    file = File.open('/home/brian/downloads/beers.csv')
    file.each do |line|
      brewery_name, beer_name, brewery_loc, brewery_web = line.split('|')
      brewery = Brewery.find_or_initialize_by_name(brewery_name.strip.split.map(&:capitalize).join(' '))
      brewery.location = brewery_loc if brewery_loc.size > 0
      brewery.website = brewery_web if brewery_web.size > 0
      brewery.save!
      beer = Beer.where(brewery_id: brewery.id).find_or_initialize_by_name(beer_name.strip.split.map(&:capitalize).join(' '))
      beer.save!
    end
  end

  desc "Import users with auto-confirm"
  task :import_users => :environment do
    file = File.open('/home/brian/downloads/users.txt')
    file.each do |line|
      name, email = line.split(',')
      user = User.new(:name => name, :email => email)
      user.password = user.password_confirmation = SecureRandom.urlsafe_base64(14)
      user.confirmed_at = Time.zone.now
      if user.save
        puts "Registered user #{user.id}: :email => #{email}, :name => #{name}"
      else
        puts "Error registering user: :email => #{email}, :name => #{name}"
      end
    end
  end

  desc "Move articles with event flag to new event resource"
  task :move_articles => :environment do
    Article.events.each do |article|
      event = Event.new
      event.title = article.title
      event.content = article.content
      event.start_at = article.start_at
      event.end_at = article.end_at
      event.location = article.location
      event.allow_comments = article.allow_comments
      event.published = article.published
      event.featured = true
      event.user_id = article.user_id
      event.created_at = article.created_at
      event.updated_at = article.updated_at
      if event.save
        puts "Event #{event.id} saved (article #{article.id})"
        if article.comments.count > 0
          puts "Article #{article.id} has #{article.comments.count} comments. Moving..."
          article.comments.each do |comment|
            comment.commentable_type = "Event"
            comment.commentable_id = event.id
            if comment.save
              puts "Comment #{comment.id} moved from article #{article.id} to event #{event.id}"
            else
              puts "Error moving comment #{comment.id} from article #{article.id} to event #{event.id}"
            end
          end
        else
          puts "Article #{article.id} has no comments."
        end
      else
        puts "Event not saved (article #{article.id})"
      end
      puts "Next article..."
    end
    puts "Finished"
  end
end
