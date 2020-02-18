def calculate_damage(your_type, opponent_type, attack, defense)
    50 * (attack / defense) * effectiveness(your_type, opponent_type)
end

def effectiveness(your_type, opponent_type)
    matchup = {
        'fire' => {'grass' => 2, 'water' => 0.5, 'electric' => 1},
        'grass' => {'fire' => 0.5, 'water' => 2, 'electric' => 1},
        'water' => {'fire' => 2, 'grass' => 0.5, 'electric' => 0.5},
        'electric' => {'fire' => 1, 'grass' => 1, 'water' => 2}
    }

    if your_type == opponent_type
        0.5
    else
        matchup[your_type][opponent_type]
    end
end