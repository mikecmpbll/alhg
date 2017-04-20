class Artifact < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  mount_uploader :file, ArtifactUploader

  belongs_to :creator, class_name: "User"

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :es_file, type: 'attachment', fields: {
          name:          { store: true },
          content:       { store: true, term_vector: "with_positions_offsets" },
          title:         { store: true },
          date:          { store: true },
        }
    end
  end

  def es_file
    if file.present?
      Base64.encode64 File.read file.path
    else
      ""
    end
  end

  def as_indexed_json options = {}
    to_json only: [:id], methods: :es_file
  end

  def self.search term
    return all unless term.present?
    a = __elasticsearch__.search(
      {
        query: {
          match: {
            "es_file.content": term
          }
        },
        highlight: {
          pre_tags: ['<em class="search-highlight">'],
          post_tags: ['</em>'],
          fields: {
            "es_file.content": {} 
          }
        }
      }
    )
  end
end
