class NotificationModel {
  String? title, id, userid;
  String? body;
  String? payload;
  DateTime? created;
  String? transactionid, senderid;
  bool? isMessageRead;

  // JobModel? job;
  // MessageModel? message;

  NotificationModel(
      {
        // this.job,
        this.created,
        this.title,
        this.userid,
        this.isMessageRead,
        this.body,
        this.payload,
        this.id,
        this.transactionid,
        this.senderid
        //  , this.message
      });

  factory NotificationModel.fromMap(var map) {
    return NotificationModel(
      body: map['body'],
      title: map['title'],
      id: map['id'],
      userid: map['userid'],
      isMessageRead: map['isMessageRead'],

      transactionid: map['transactionid'],
      senderid: map['senderid'],
      payload: map['payload'],
      created: map['created'].toDate(),

      // job: JobModel.fromMap(map['job']),
      // message: MessageModel.fromMap(map['message']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'job': (job ?? ""),
      'title': title ?? '',
      'body': body ?? '',
      'id': id ?? '',
      'userid': userid ?? '',
      'transactionid': transactionid ?? '',
      'senderid': senderid ?? '',
      'isMessageRead': isMessageRead ?? false,

      'payload': payload ?? '',
      'created': created ?? DateTime.now(),
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userid'] = userid;
    data['title'] = title;
    data['body'] = body;
    data['transactionid'] = transactionid;
    data['isMessageRead'] = isMessageRead;
    data['senderid'] = senderid;
    data['payload'] = payload;
    data['created'] = created;
    return data;
  }
}