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
end
