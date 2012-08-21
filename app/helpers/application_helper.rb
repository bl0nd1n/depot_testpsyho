module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end

module ApplicationHelper
  # this method will embed the code from the partial
  def youtube_video(url)
    render :partial => 'shared/video', :locals => { :url => url }
  end 
end

module ApplicationHelper
  # this method will embed the code from the partial
  def youtube_video_thumb(url)
    render :partial => 'shared/video_thumb', :locals => { :url => url }
  end 
end