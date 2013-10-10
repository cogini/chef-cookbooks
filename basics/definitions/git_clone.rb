define :git_clone, :destination => nil do

  url = params[:name]
  destination = params[:destination]

  execute "git clone #{url} #{destination}" do
    not_if { Dir.exists?(destination) }
  end

end
