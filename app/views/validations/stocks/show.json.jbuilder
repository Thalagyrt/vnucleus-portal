json.plan do |json|
  json.id @plan.id
  json.name @plan.name
end

json.cluster do |json|
  json.id @cluster.id
  json.name @cluster.name
end

json.stock @stock