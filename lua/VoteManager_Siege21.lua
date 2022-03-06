local kMinVotesNeeded = 1
function VoteManager:GetNumVotesNeeded()
	-- Round to nearest number of players (3.4 = 3, 3.5 = 4).
	-- Don't ever require more votes than there are players
	-- Always require at least 2 votes when there are two or more players
	-- Always require 1 vote no matter what (or things break)
    local numPlayers = math.max( 1, self.numPlayers )
    local voteRoundedAmountToPass = math.floor( (numPlayers * self.teamPercentNeeded) + 0.5 )
    local minYesVoteOverride = self.teamMinYesVoteOverride
    local numYesVoteRequired = math.min( math.max(kMinVotesNeeded, voteRoundedAmountToPass), numPlayers)
    return math.max(numYesVoteRequired, minYesVoteOverride)
end
