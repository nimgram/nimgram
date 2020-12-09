type
    StatsBroadcastStats* = ref object of StatsBroadcastStatsI
        period*: StatsDateRangeDaysI
        followers*: StatsAbsValueAndPrevI
        views_per_post*: StatsAbsValueAndPrevI
        shares_per_post*: StatsAbsValueAndPrevI
        enabled_notifications*: StatsPercentValueI
        growth_graph*: StatsGraphI
        followers_graph*: StatsGraphI
        mute_graph*: StatsGraphI
        top_hours_graph*: StatsGraphI
        interactions_graph*: StatsGraphI
        iv_interactions_graph*: StatsGraphI
        views_by_source_graph*: StatsGraphI
        new_followers_by_source_graph*: StatsGraphI
        languages_graph*: StatsGraphI
        recent_message_interactions*: seq[MessageInteractionCountersI]
    StatsMegagroupStats* = ref object of StatsMegagroupStatsI
        period*: StatsDateRangeDaysI
        members*: StatsAbsValueAndPrevI
        messages*: StatsAbsValueAndPrevI
        viewers*: StatsAbsValueAndPrevI
        posters*: StatsAbsValueAndPrevI
        growth_graph*: StatsGraphI
        members_graph*: StatsGraphI
        new_members_by_source_graph*: StatsGraphI
        languages_graph*: StatsGraphI
        messages_graph*: StatsGraphI
        actions_graph*: StatsGraphI
        top_hours_graph*: StatsGraphI
        weekdays_graph*: StatsGraphI
        top_posters*: seq[StatsGroupTopPosterI]
        top_admins*: seq[StatsGroupTopAdminI]
        top_inviters*: seq[StatsGroupTopInviterI]
        users*: seq[UserI]
    StatsMessageStats* = ref object of StatsMessageStatsI
        views_graph*: StatsGraphI
method getTypeName*(self: StatsBroadcastStats): string = "StatsBroadcastStats"
method getTypeName*(self: StatsMegagroupStats): string = "StatsMegagroupStats"
method getTypeName*(self: StatsMessageStats): string = "StatsMessageStats"

method TLEncode*(self: StatsBroadcastStats): seq[uint8] =
    result = TLEncode(uint32(3187114900))
    result = result & TLEncode(self.period)
    result = result & TLEncode(self.followers)
    result = result & TLEncode(self.views_per_post)
    result = result & TLEncode(self.shares_per_post)
    result = result & TLEncode(self.enabled_notifications)
    result = result & TLEncode(self.growth_graph)
    result = result & TLEncode(self.followers_graph)
    result = result & TLEncode(self.mute_graph)
    result = result & TLEncode(self.top_hours_graph)
    result = result & TLEncode(self.interactions_graph)
    result = result & TLEncode(self.iv_interactions_graph)
    result = result & TLEncode(self.views_by_source_graph)
    result = result & TLEncode(self.new_followers_by_source_graph)
    result = result & TLEncode(self.languages_graph)
    result = result & TLEncode(cast[seq[TL]](self.recent_message_interactions))
method TLDecode*(self: StatsBroadcastStats, bytes: var ScalingSeq[uint8]) = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.period = cast[StatsDateRangeDaysI](tempObj)
    tempObj.TLDecode(bytes)
    self.followers = cast[StatsAbsValueAndPrevI](tempObj)
    tempObj.TLDecode(bytes)
    self.views_per_post = cast[StatsAbsValueAndPrevI](tempObj)
    tempObj.TLDecode(bytes)
    self.shares_per_post = cast[StatsAbsValueAndPrevI](tempObj)
    tempObj.TLDecode(bytes)
    self.enabled_notifications = cast[StatsPercentValueI](tempObj)
    tempObj.TLDecode(bytes)
    self.growth_graph = cast[StatsGraphI](tempObj)
    tempObj.TLDecode(bytes)
    self.followers_graph = cast[StatsGraphI](tempObj)
    tempObj.TLDecode(bytes)
    self.mute_graph = cast[StatsGraphI](tempObj)
    tempObj.TLDecode(bytes)
    self.top_hours_graph = cast[StatsGraphI](tempObj)
    tempObj.TLDecode(bytes)
    self.interactions_graph = cast[StatsGraphI](tempObj)
    tempObj.TLDecode(bytes)
    self.iv_interactions_graph = cast[StatsGraphI](tempObj)
    tempObj.TLDecode(bytes)
    self.views_by_source_graph = cast[StatsGraphI](tempObj)
    tempObj.TLDecode(bytes)
    self.new_followers_by_source_graph = cast[StatsGraphI](tempObj)
    tempObj.TLDecode(bytes)
    self.languages_graph = cast[StatsGraphI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.recent_message_interactions = cast[seq[MessageInteractionCountersI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: StatsMegagroupStats): seq[uint8] =
    result = TLEncode(uint32(4018141462))
    result = result & TLEncode(self.period)
    result = result & TLEncode(self.members)
    result = result & TLEncode(self.messages)
    result = result & TLEncode(self.viewers)
    result = result & TLEncode(self.posters)
    result = result & TLEncode(self.growth_graph)
    result = result & TLEncode(self.members_graph)
    result = result & TLEncode(self.new_members_by_source_graph)
    result = result & TLEncode(self.languages_graph)
    result = result & TLEncode(self.messages_graph)
    result = result & TLEncode(self.actions_graph)
    result = result & TLEncode(self.top_hours_graph)
    result = result & TLEncode(self.weekdays_graph)
    result = result & TLEncode(cast[seq[TL]](self.top_posters))
    result = result & TLEncode(cast[seq[TL]](self.top_admins))
    result = result & TLEncode(cast[seq[TL]](self.top_inviters))
    result = result & TLEncode(cast[seq[TL]](self.users))
method TLDecode*(self: StatsMegagroupStats, bytes: var ScalingSeq[uint8]) = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.period = cast[StatsDateRangeDaysI](tempObj)
    tempObj.TLDecode(bytes)
    self.members = cast[StatsAbsValueAndPrevI](tempObj)
    tempObj.TLDecode(bytes)
    self.messages = cast[StatsAbsValueAndPrevI](tempObj)
    tempObj.TLDecode(bytes)
    self.viewers = cast[StatsAbsValueAndPrevI](tempObj)
    tempObj.TLDecode(bytes)
    self.posters = cast[StatsAbsValueAndPrevI](tempObj)
    tempObj.TLDecode(bytes)
    self.growth_graph = cast[StatsGraphI](tempObj)
    tempObj.TLDecode(bytes)
    self.members_graph = cast[StatsGraphI](tempObj)
    tempObj.TLDecode(bytes)
    self.new_members_by_source_graph = cast[StatsGraphI](tempObj)
    tempObj.TLDecode(bytes)
    self.languages_graph = cast[StatsGraphI](tempObj)
    tempObj.TLDecode(bytes)
    self.messages_graph = cast[StatsGraphI](tempObj)
    tempObj.TLDecode(bytes)
    self.actions_graph = cast[StatsGraphI](tempObj)
    tempObj.TLDecode(bytes)
    self.top_hours_graph = cast[StatsGraphI](tempObj)
    tempObj.TLDecode(bytes)
    self.weekdays_graph = cast[StatsGraphI](tempObj)
    var tempVector = newSeq[TL]()
    tempVector.TLDecode(bytes)
    self.top_posters = cast[seq[StatsGroupTopPosterI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.top_admins = cast[seq[StatsGroupTopAdminI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.top_inviters = cast[seq[StatsGroupTopInviterI]](tempVector)
    tempVector.setLen(0)
    tempVector.TLDecode(bytes)
    self.users = cast[seq[UserI]](tempVector)
    tempVector.setLen(0)
method TLEncode*(self: StatsMessageStats): seq[uint8] =
    result = TLEncode(uint32(2308567701))
    result = result & TLEncode(self.views_graph)
method TLDecode*(self: StatsMessageStats, bytes: var ScalingSeq[uint8]) = 
    var tempObj = new TL
    tempObj.TLDecode(bytes)
    self.views_graph = cast[StatsGraphI](tempObj)
