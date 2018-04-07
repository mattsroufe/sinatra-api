class Department < ActiveRecord::Base
end

__END__

def index
  movies = MoviesQuery.for_user(current_user)
  serializer_klass = MovieSerializer.for_user(current_user)
  @model = serializer_klass.new(movies, options).serializable_hash
end

class AdminMovieSerializer
end

class CustomerMovieSerializer
end

