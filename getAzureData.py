from azure.eventhub import EventHubConsumerClient

CONNECTION_STR = "Endpoint=sb://iothub-ns-greenroof-57444460-c3a391cc20.servicebus.windows.net/;SharedAccessKeyName=iothubowner;SharedAccessKey=kySQoYRbxkmfnC86ZrgZBe1XHjnWot65XAIoTPpifbs=;EntityPath=greenroof"

EVENTHUB_NAME = "greenroof"   # from Built-in endpoints → events

CONSUMER_GROUP = "$Default"

def on_event(partition_context, event):
    print("Received:", event.body_as_str())
    partition_context.update_checkpoint(event)

client = EventHubConsumerClient.from_connection_string(
    conn_str=CONNECTION_STR,
    consumer_group=CONSUMER_GROUP,
    eventhub_name=EVENTHUB_NAME   # 🔥 REQUIRED
)

with client:
    client.receive(on_event=on_event, starting_position="-1")