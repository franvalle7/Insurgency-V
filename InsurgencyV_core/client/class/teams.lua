AddRelationshipGroup('resistance')
AddRelationshipGroup('army')

SetRelationshipBetweenGroups(5, 'resistance', 'army')
SetRelationshipBetweenGroups(5, 'army', 'resistance')


function JoinArmyTeam()
    SetPedRelationshipGroupHash(PlayerPedId(), 'army')
end


function JoinResistanceTeam()
    SetPedRelationshipGroupHash(PlayerPedId(), 'resistance')
end