# == Schema Information
#
# Table name: app_files
#
#  id         :bigint           not null, primary key
#  file_type  :string
#  file_url   :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AppFile < ApplicationRecord
end
