class Comparer
  def check(main_date, check_date)
    # SourceHouseInfo.where('Date(ecxuted_at) in (?, ?)', main_date, check_date).group(:ecxuted_at).having('Max(price) != Min(price)')
    # SourceHouseInfo.select('max(price)').where('Date(ecxuted_at) in (?, ?)', main_date, check_date).group(:feature_id).having('max(price) != min(price) OR count(*) < 2')

    dates = [main_date, check_date]
    changed_source_groups = SourceHouseInfo.select(:feature_id).where(ecxuted_date: dates).group(:feature_id).having('max(price) != min(price) OR count(*) < ?', dates.count)
    changed_feature_ids = changed_source_groups.all.collect(&:feature_id)
    changed_sources = SourceHouseInfo.where(ecxuted_date: dates).where(feature_id: changed_feature_ids)

    changes_hash = {}
    all_date_hash = {}
    enpty_source = SourceHouseInfo.new
    changed_sources.each do |source|
      # changes_hash[source.ecxuted_date] ||= {}
      feature_id = source.feature_id
      changes_hash[feature_id] ||= Hash.new(enpty_source)
      changes_hash[feature_id][source.ecxuted_date] = source
      all_date_hash[source.ecxuted_date] = nil
    end; nil

    all_date = all_date_hash.keys

    [changes_hash, all_date]
  end

  def self.test
    SourceHouseInfo.all.each do |s|
      s.ecxuted_date = s.ecxuted_at.to_date
      s.save!
    end; nil
  end
end
