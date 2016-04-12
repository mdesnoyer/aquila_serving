"""
Send JPEG image to aquila_inference server for classification.
"""

import os
import sys
import threading

# This is a placeholder for a Google-internal import.

from grpc.beta import implementations
import numpy
import tensorflow as tf

from tensorflow_serving.example import aquila_inference_pb2


tf.app.flags.DEFINE_string('server', 'localhost:9000',
                           'aquila_inference service host:port')
tf.app.flags.DEFINE_string('image', '', 'path to image in JPEG format')
FLAGS = tf.app.flags.FLAGS

WORKING_DIR = os.path.dirname(os.path.realpath(__file__))


def main(_):
  host, port = FLAGS.server.split(':')
  channel = implementations.insecure_channel(host, int(port))
  stub = aquila_inference_pb2.beta_create_AquilaService_stub(channel)
  # Send request
  with open(FLAGS.image, 'rb') as f:
    # See aquila_inference.proto for gRPC request/response details.
    data = f.read()
    request = aquila_inference_pb2.AquilaRequest()
    request.jpeg_encoded = data
    result = stub.Classify(request, 10.0)  # 10 secs timeout
    for i in range(NUM_CLASSES):
      index = result.classes[i]
      score = result.scores[i]
    print 'Computed image valence: %.2f' % (result.valence)


if __name__ == '__main__':
  tf.app.run()
