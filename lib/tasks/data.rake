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
end
