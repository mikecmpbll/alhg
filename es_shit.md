    Artifact.__elasticsearch__.delete_index!
    Artifact.__elasticsearch__.create_index!
    Artifact.all.each{ |a| a.__elasticsearch__.index_document }
