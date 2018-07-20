# frozen_string_literal: true

module DirtyHack

  def params
    @params ||= begin
      og_params  = super
      @search_param = "%#{og_params['search']['value'].downcase}%" rescue nil
      og_params.except "search"
    end
  end

  SEARCH_SQL = <<-SQL
    (
      LOWER(artists.artist_name) LIKE (?)
      OR
      LOWER(songs.song_name) LIKE (?)
    )
  SQL

  def retrieve_records
    _records = get_sum_records
    _records = sort_records(_records)     if datatable.orderable?
    _records = paginate_records(_records) if datatable.paginate?
    _records
  end

  def records_filtered_count
    get_sum_records.count(:all)
  end

  def get_sum_records
    @get_sum_records ||= begin
      _records = get_raw_records
      _records = _records.where(build_conditions_for_selected_columns)
      _records = _records.where(SEARCH_SQL, @search_param, @search_param) if @search_param.present? && @search_param != "%%"
      _records
    end
  end
end
