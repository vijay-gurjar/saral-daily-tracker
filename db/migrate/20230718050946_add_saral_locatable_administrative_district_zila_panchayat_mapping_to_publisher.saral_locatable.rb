# This migration comes from saral_locatable (originally 20211208092050)
class AddSaralLocatableAdministrativeDistrictZilaPanchayatMappingToPublisher < ActiveRecord::Migration[6.1]
    def up
        if ENV['IS_MASTER']
          execute "ALTER PUBLICATION #{ENV['PUBLISHER_NAME']} ADD TABLE saral_locatable_administrative_district_zila_panchayat_mappings"
        end
    end

    def down
        if ENV['IS_MASTER']
          execute "ALTER PUBLICATION #{ENV['PUBLISHER_NAME']} DROP TABLE saral_locatable_administrative_district_zila_panchayat_mappings"
        end
    end
end
