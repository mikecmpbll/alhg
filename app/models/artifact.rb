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
      indexes :filename
      indexes :description
    end
  end

  def filename
    fn = super

    if fn.present?
      fn
    else
      file_identifier
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
    as_json only: [:id, :description], methods: [:es_file, :filename]
  end

  def self.search term
    return all unless term.present?
    a = __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: term,
            fields: ["es_file.content", "filename", "description"]
          }
        },
        highlight: {
          pre_tags: ['<em class="search-highlight">'],
          post_tags: ['</em>'],
          fields: {
            "es_file.content": {},
            filename: { number_of_fragments: 0 },
            description: {}
          }
        }
      }
    )
  end
end
