local plyMeta = FindMetaTable( "Player" )

function plyMeta:ResetWarnings( )
	if not WonderWarnings.Config.Ban["Reset"] then return end

	self:SetPData( 'warnings_kicked', false )
	self:SetPData( 'warnings', 0 )

	if WonderWarnings.Config.Actions["NetworkVariable"] then
		self:SetNWInt( 'warnings', 0 ) 
	end	
end

function plyMeta:AddWarning( int )
	self:SetPData( 'warnings_month', os.date( "%m", os.time() ) )
	self:SetPData( 'warnings', iWarnTotal )

	if WonderWarnings.Config.Actions["NetworkVariable"] then
		self:SetNWInt( 'warnings', 0 ) 
	end	
end

