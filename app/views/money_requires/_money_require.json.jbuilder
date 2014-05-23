unless money_require
  json.null!
else
  json.extract! money_require, :id, :money, :share, :deadline, :status, :min_money
  json.is_investor current_user.has_role?(:investor)
  json.format_status format_status(money_require.status)
  if money_require.opened_at.present?
    # 开始与结束时间
    json.opened_at format_date(money_require.opened_at)
    json.ended_at format_date(money_require.ended_at)
    json.format_start_end_time format_start_end_time(money_require.opened_at, money_require.ended_at)
  end
  
  if money_require.opened?
    # 剩余天数
    json.left money_require.left
    json.syndicate_money money_require.syndicate_money

    # 可投资信息
    json.syndicate do
      json.can current_user.has_role?(:investor)
      json.already_money money_require.already_money(current_user)
      json.already_investment_id money_require.already_investment_id(current_user)
    end

  end

  if money_require.closed?
    json.extract! money_require, :cost, :success
  end

  if money_require.leader_user
    json.leader do
      json.extract! money_require.leader_user, :name, :id
      json.avatar money_require.leader_user.avatar_url
      json.me money_require.leader_user == current_user
    end
  end
end
