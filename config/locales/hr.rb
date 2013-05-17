rule = lambda do |n|
  case n
  when 1    then :one
  when 2..4 then :few
  else           :many
  end
end

{
  hr: {
    i18n: {
      plural: {
        keys: [:one, :few, :many],
        rule: rule,
      }
    }
  }
}
