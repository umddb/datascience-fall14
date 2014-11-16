/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


//package org.umd.assignment.spout;

package org.umd.assignment.spout;

import java.util.Map;
import java.util.concurrent.LinkedBlockingQueue;

import twitter4j.FilterQuery;
import twitter4j.StallWarning;
import twitter4j.Status;
import twitter4j.StatusDeletionNotice;
import twitter4j.StatusListener;
import twitter4j.TwitterStream;
import twitter4j.TwitterStreamFactory;
import twitter4j.auth.AccessToken;
import twitter4j.conf.ConfigurationBuilder;

import backtype.storm.Config;
import backtype.storm.spout.SpoutOutputCollector;
import backtype.storm.task.TopologyContext;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseRichSpout;
import backtype.storm.tuple.Fields;
import backtype.storm.tuple.Values;
import backtype.storm.utils.Utils;

@SuppressWarnings("serial")
public class TwitterSampleSpout extends BaseRichSpout {

	SpoutOutputCollector _collector;
	LinkedBlockingQueue<String> queue = null;
	TwitterStream _twitterStream;
	String consumerKey;
	String consumerSecret;
	String accessToken;
	String accessTokenSecret;
	String[] keyWords;
	
	public TwitterSampleSpout(String consumerKey, String consumerSecret,
			String accessToken, String accessTokenSecret, String[] keyWords) {
		this.consumerKey = consumerKey;
		this.consumerSecret = consumerSecret;
		this.accessToken = accessToken;
		this.accessTokenSecret = accessTokenSecret;
		this.keyWords = keyWords;
	}


	//----------------------- Task 0 -----------------------------------------
	//
	//  Use the following link (for visual help) to create a Twitter App for yourselves. In summary,
	//	the steps are:
	//				(a) Go to apps.twitter.com
	//				(b) Create an App [Put any website as an URL]
	//				(c) Go to "keys and Access Token tab"
	//				(d) Create you access token
	//				(e) Copy over the ConsumerKey, consumerSecret, accesstoken, and accessTokenSecret
	//				in the TwitterSampleSpout()
	//
	//	https://dev.twitter.com/oauth/overview/application-owner-access-tokens
	//	
	//
	//
	//------------------------------------------------------------------------

	public TwitterSampleSpout() {		
		this.consumerKey = "aqMhHjo25IFTlQqmT3A1YNnPVs";
		this.consumerSecret = "bdGjNYhusZSbzLQ6695veAJG9KtkBtAHYZwwLEnfGujqGz5j987";
		this.accessToken = "c11412092-ks3eYiWAL8SKcTAJ3SMDdAkBJss7gOHMTk2YlwPFZ";
		this.accessTokenSecret = "diDFa3JCYbgBv3D5MZei2xdHkGdZcDEqLGJcbNx7P5fKmv";
		this.keyWords = new String[1];
		this.keyWords[0] = "obama"; /* Filters All Tweets with word Obama */
	}

	@Override
	public void open(Map conf, TopologyContext context,
			SpoutOutputCollector collector) {
		queue = new LinkedBlockingQueue<String>(1000);
		_collector = collector;

		StatusListener listener = new StatusListener() {

			@Override
			public void onStatus(Status status) {
			
				queue.offer(status.getText());
			}

			@Override
			public void onDeletionNotice(StatusDeletionNotice sdn) {
			}

			@Override
			public void onTrackLimitationNotice(int i) {
			}

			@Override
			public void onScrubGeo(long l, long l1) {
			}

			@Override
			public void onException(Exception ex) {
			}

			@Override
			public void onStallWarning(StallWarning arg0) {
				// TODO Auto-generated method stub

			}

		};

		TwitterStream twitterStream = new TwitterStreamFactory(
				new ConfigurationBuilder().setJSONStoreEnabled(true).build())
				.getInstance();

		twitterStream.addListener(listener);
		twitterStream.setOAuthConsumer(consumerKey, consumerSecret);
		AccessToken token = new AccessToken(accessToken, accessTokenSecret);
		twitterStream.setOAuthAccessToken(token);
		
		if (keyWords.length == 0) {

			twitterStream.sample();
		}

		else {

			FilterQuery query = new FilterQuery().track(keyWords);
			twitterStream.filter(query);
		}

	}

	@Override
	public void nextTuple() {
		String ret = queue.poll();
		if (ret == null) {
			Utils.sleep(50);
		} else {
		     
			_collector.emit(new Values(ret));

		}
	}

	@Override
	public void close() {
		_twitterStream.shutdown();
	}

	@Override
	public Map<String, Object> getComponentConfiguration() {
		Config ret = new Config();
		ret.setMaxTaskParallelism(1);
		return ret;
	}

	@Override
	public void ack(Object id) {
	}

	@Override
	public void fail(Object id) {
	}

	@Override
	public void declareOutputFields(OutputFieldsDeclarer declarer) {
		declarer.declare(new Fields("tweet"));
	}

}
