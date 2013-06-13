class LastActivity
  def self.for(user)
    new(user)
  end

  def initialize(user)
    @user = user
  end

  def read
    time = $redis.get(key)
    Time.parse(time) if time
  end

  def save(time)
    $redis.set(key, time)
  end

  private

  def key
    "last_activity:#{@user.type}:#{@user.username}"
  end
end
