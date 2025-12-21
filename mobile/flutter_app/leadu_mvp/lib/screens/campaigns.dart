import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  List campaigns = [];

  @override
  void initState() {
    super.initState();
    loadCampaigns();
  }

  void loadCampaigns() async {
    campaigns = await ApiService.getCampaigns();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Campaigns")),
      body: ListView.builder(
        itemCount: campaigns.length,
        itemBuilder: (_, i) {
          final c = campaigns[i];
          return ListTile(
            title: Text(c["title"]),
            subtitle: Text(c["message"]),
          );
        },
      ),
    );
  }
}
