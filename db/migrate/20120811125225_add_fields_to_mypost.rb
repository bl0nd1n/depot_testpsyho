class AddFieldsToMypost < ActiveRecord::Migration
  def change
	
   add_column :myposts, :video_url, :string
   add_column :myposts, :post_url, :string
   
   
  end
end
