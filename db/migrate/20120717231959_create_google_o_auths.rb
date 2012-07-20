class CreateGoogleOAuths < ActiveRecord::Migration
  def change
    create_table :google_o_auths do |t|

      t.timestamps
    end
  end
end
